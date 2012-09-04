-- folder
create table mailbox (path text, uidvalidity number, unseen_count number, count number, oldest_uid number);
create index mailbox_idx on mailbox(path);

-- message
-- create table message (uid number, msgid text, has_headers number, imapmsg blob, mailbox_id number, preview text, has_preview number, date date, flags number, original_flags number, from_mailbox text, conversation_id number, flags_dirty number, deleted number, is_flagged number, is_seen number, is_deleted number, is_notified number, dest_mailbox text, has_dest_mailbox number, is_local number);
create table message (uid number, msgid text, has_headers number, mailbox_id number, date date, flags number, original_flags number, conversation_id number, flags_dirty number, deleted number, is_flagged number, is_seen number, is_deleted number, is_notified number, is_local number);
create index message_uid_mailbox_id_idx on message(uid, mailbox_id);
create index message_msgid_idx on message(msgid);
create index message_conversation_id_idx on message(conversation_id);
create index message_mailbox_id_idx on message(mailbox_id);
create index message_mailbox_id_is_seen_idx on message(mailbox_id, is_seen);

-- hint for conversation construction
create table message_relation (relation_id number, msgid text);
create index message_relation_relation_id_idx on message_relation(relation_id);
create index message_relation_msgid_idx on message_relation(msgid);

-- candidates for conversation
create table conversation_message_relation (relation_id number, conversation_id number);
create index conversation_message_relation_relation_id_idx on conversation_message_relation(relation_id);

-- conversation
-- create table conversation (extracted_subject text, subject text, last_sent_message_id number, last_sent_message_date date, last_received_message_id number, last_received_message_date date, int flags);
-- create table conversation (extracted_subject text, subject text, last_received_message_date date);
create table conversation (extracted_subject text, subject text);
-- create table conversation_recipient (conversation_id number, display_name text, mailbox text);
-- create table conversation_from (conversation_id number, display_name text, mailbox text);
-- create table conversation_message (conversation_id number, message_id number, mailbox_id number);
-- create index conversation_message_message_id_idx on conversation_message (message_id);
-- create index conversation_message_conversation_id_idx on conversation_message (conversation_id);
-- create index conversation_message_mailbox_id_idx on conversation_message (mailbox_id);
-- create index conversation_subject_idx on conversation (extracted_subject)

create table conversation_date (conversation_id number, mailbox_id number, last_received_message_date date, visibility number);
create index conversation_date_conversation_id_mailbox_id_idx on conversation_date (conversation_id, mailbox_id);
-- create index conversation_date_mailbox_id_idx on conversation_date (mailbox_id);
create index conversation_date_mailbox_id_visibility_idx on conversation_date (mailbox_id, visibility);
create index conversation_date_conversation_id_idx on conversation_date (conversation_id);
-- create index conversation_date_mailbox_id_idx on conversation_date (mailbox_id);
-- create index conversation_date_conversation_id_idx on conversation_date (conversation_id);
-- create table conversation_cache (conversation_id number, cache_data blob)
-- create index conversation_cache_conversation_id_idx on conversation_cache (conversation_id);

-- attachment
create table attachment (mailbox_id number, message_id number, partid text, is_text number, contents blob, has_contents number, uid number);
create index attachment_message_id_idx on attachment(message_id);
create index attachment_message_id_partid_idx on attachment(message_id, partid);
create index attachment_mailbox_id_has_contents_idx on attachment(mailbox_id, has_contents);
create index attachment_mailbox_id_has_contents_is_text_uid_idx on attachment(mailbox_id, has_contents, is_text, uid);

-- pre-full-text-index
create table message_header_fts (message_id number, conversation_id number, from_address text, recipient text, subject text, date date, mailbox_id number);
create table message_contents_fts (message_id number, conversation_id number, contents text, date date, mailbox_id number);
create table message_attachments_fts (message_id number, attachments text);
create index message_header_fts_message_id_idx on message_header_fts(message_id)
create index message_contents_fts_message_id_idx on message_contents_fts(message_id)
create index message_attachments_fts_message_id_idx on message_attachments_fts(message_id)
create table message_delete_fts (message_id number);

create table message_copy (message_id number, uid number, mailbox_id number, dest_mailbox_id number, delete_source number)
create index message_copy_mailbox_id on message_copy(mailbox_id)
-- create index message_copy_uid_idx on message_copy(uid)
create index message_copy_message_id_idx on message_copy(message_id)

-- hidden messages
create table message_hidden (msgid text, mailbox_id number)
create index message_hidden_mailbox_id_idx on message_hidden(mailbox_id)
create index message_hidden_msgid_mailbox_id_idx on message_hidden(msgid, mailbox_id)

-- permanent hidden messages
create table permanent_message_hidden (msgid text, mailbox_id number)
create index permanent_message_hidden_mailbox_id_idx on permanent_message_hidden(mailbox_id)
create index permanent_message_hidden_msgid_mailbox_id_idx on permanent_message_hidden(msgid, mailbox_id)

-- messages to delete
create table message_msgid_to_delete (msgid text, mailbox_id number)
create index message_msgid_to_delete_mailbox_id_idx on message_msgid_to_delete(mailbox_id)
create index message_msgid_to_delete_msgid_mailbox_id_idx on message_msgid_to_delete(msgid, mailbox_id)

create table message_uid_to_delete (uid number, mailbox_id number)
create index message_uid_to_delete_mailbox_id_idx on message_uid_to_delete(mailbox_id)
create index message_uid_to_delete_uid_mailbox_id_idx on message_uid_to_delete(uid, mailbox_id)

create table message_label_pending_sync (message_id number, mailbox_id number)
create index message_label_pending_sync_message_id_idx on message_label_pending_sync(message_id);

-- label to delete
create table message_delete_label (uid number, mailbox_id number, label_to_delete_id number)
create index message_delete_label_mailbox_id on message_delete_label(mailbox_id)

-- pop uidl
create table message_pop3_uid (uid integer primary key autoincrement, pop3id text, fetched number, fetch_date date)
create index message_pop3_uid_uid on message_pop3_uid (uid)
